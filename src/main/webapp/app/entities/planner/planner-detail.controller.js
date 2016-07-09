(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('PlannerDetailController', PlannerDetailController);

    PlannerDetailController.$inject = ['$scope', '$rootScope', '$stateParams', 'entity', 'Planner', 'User', 'Recipe'];

    function PlannerDetailController($scope, $rootScope, $stateParams, entity, Planner, User, Recipe) {
        var vm = this;

        vm.planner = entity;

        var unsubscribe = $rootScope.$on('plannerApp:plannerUpdate', function(event, result) {
            vm.planner = result;
        });
        $scope.$on('$destroy', unsubscribe);
    }
})();
