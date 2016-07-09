(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('IngredientDialogController', IngredientDialogController);

    IngredientDialogController.$inject = ['$timeout', '$scope', '$stateParams', '$uibModalInstance', 'entity', 'Ingredient', 'Recipe'];

    function IngredientDialogController ($timeout, $scope, $stateParams, $uibModalInstance, entity, Ingredient, Recipe) {
        var vm = this;

        vm.ingredient = entity;
        vm.clear = clear;
        vm.save = save;
        vm.recipes = Recipe.query();

        $timeout(function (){
            angular.element('.form-group:eq(1)>input').focus();
        });

        function clear () {
            $uibModalInstance.dismiss('cancel');
        }

        function save () {
            vm.isSaving = true;
            if (vm.ingredient.id !== null) {
                Ingredient.update(vm.ingredient, onSaveSuccess, onSaveError);
            } else {
                Ingredient.save(vm.ingredient, onSaveSuccess, onSaveError);
            }
        }

        function onSaveSuccess (result) {
            $scope.$emit('plannerApp:ingredientUpdate', result);
            $uibModalInstance.close(result);
            vm.isSaving = false;
        }

        function onSaveError () {
            vm.isSaving = false;
        }


    }
})();
