(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('RecipeController', RecipeController);

    RecipeController.$inject = ['$scope', '$state', 'Recipe'];

    function RecipeController ($scope, $state, Recipe) {
        var vm = this;
        
        vm.recipes = [];

        loadAll();

        function loadAll() {
            Recipe.query(function(result) {
                vm.recipes = result;
            });
        }
    }
})();
