(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('PlannerDeleteController',PlannerDeleteController);

    PlannerDeleteController.$inject = ['$uibModalInstance', 'entity', 'Planner'];

    function PlannerDeleteController($uibModalInstance, entity, Planner) {
        var vm = this;

        vm.planner = entity;
        vm.clear = clear;
        vm.confirmDelete = confirmDelete;
        
        function clear () {
            $uibModalInstance.dismiss('cancel');
        }

        function confirmDelete (id) {
            Planner.delete({id: id},
                function () {
                    $uibModalInstance.close(true);
                });
        }
    }
})();
