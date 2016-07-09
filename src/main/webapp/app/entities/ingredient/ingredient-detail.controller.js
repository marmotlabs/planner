(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('IngredientDetailController', IngredientDetailController);

    IngredientDetailController.$inject = ['$scope', '$rootScope', '$stateParams', 'entity', 'Ingredient', 'Recipe'];

    function IngredientDetailController($scope, $rootScope, $stateParams, entity, Ingredient, Recipe) {
        var vm = this;

        vm.ingredient = entity;

        var unsubscribe = $rootScope.$on('plannerApp:ingredientUpdate', function(event, result) {
            vm.ingredient = result;
        });
        $scope.$on('$destroy', unsubscribe);
    }
})();
