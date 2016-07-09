(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('RecipeDetailController', RecipeDetailController);

    RecipeDetailController.$inject = ['$scope', '$rootScope', '$stateParams', 'entity', 'Recipe', 'Ingredient', 'Planner'];

    function RecipeDetailController($scope, $rootScope, $stateParams, entity, Recipe, Ingredient, Planner) {
        var vm = this;

        vm.recipe = entity;

        var unsubscribe = $rootScope.$on('plannerApp:recipeUpdate', function(event, result) {
            vm.recipe = result;
        });
        $scope.$on('$destroy', unsubscribe);
    }
})();
