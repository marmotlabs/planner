(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('PlannerDialogController', PlannerDialogController);

    PlannerDialogController.$inject = ['$timeout', '$scope', '$stateParams', '$uibModalInstance', 'entity', 'Planner', 'User', 'Recipe'];

    function PlannerDialogController ($timeout, $scope, $stateParams, $uibModalInstance, entity, Planner, User, Recipe) {
        var vm = this;

        vm.planner = entity;
        vm.clear = clear;
        vm.datePickerOpenStatus = {};
        vm.openCalendar = openCalendar;
        vm.save = save;
        vm.users = User.query();
        vm.recipes = Recipe.query();

        $timeout(function (){
            angular.element('.form-group:eq(1)>input').focus();
        });

        function clear () {
            $uibModalInstance.dismiss('cancel');
        }

        function save () {
            vm.isSaving = true;
            if (vm.planner.id !== null) {
                Planner.update(vm.planner, onSaveSuccess, onSaveError);
            } else {
                Planner.save(vm.planner, onSaveSuccess, onSaveError);
            }
        }

        function onSaveSuccess (result) {
            $scope.$emit('plannerApp:plannerUpdate', result);
            $uibModalInstance.close(result);
            vm.isSaving = false;
        }

        function onSaveError () {
            vm.isSaving = false;
        }

        vm.datePickerOpenStatus.date = false;

        function openCalendar (date) {
            vm.datePickerOpenStatus[date] = true;
        }
    }
})();
