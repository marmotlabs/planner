(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('RecipeDialogController', RecipeDialogController);

    RecipeDialogController.$inject = ['$timeout', '$scope', '$stateParams', '$uibModalInstance', 'entity', 'Recipe', 'Ingredient', 'Planner'];

    function RecipeDialogController ($timeout, $scope, $stateParams, $uibModalInstance, entity, Recipe, Ingredient, Planner) {
        var vm = this;

        vm.recipe = entity;
        vm.clear = clear;
        vm.save = save;
        vm.ingredients = Ingredient.query();
        vm.planners = Planner.query();

        $timeout(function (){
            angular.element('.form-group:eq(1)>input').focus();
        });

        function clear () {
            $uibModalInstance.dismiss('cancel');
        }

        function save () {
            vm.isSaving = true;
            if (vm.recipe.id !== null) {
                Recipe.update(vm.recipe, onSaveSuccess, onSaveError);
            } else {
                Recipe.save(vm.recipe, onSaveSuccess, onSaveError);
            }
        }

        function onSaveSuccess (result) {
            $scope.$emit('plannerApp:recipeUpdate', result);
            $uibModalInstance.close(result);
            vm.isSaving = false;
        }

        function onSaveError () {
            vm.isSaving = false;
        }


    }
})();
