(function() {
    'use strict';

    angular
        .module('plannerApp')
        .controller('PlannerController', PlannerController);

    PlannerController.$inject = ['$scope', '$state', 'Planner'];

    function PlannerController ($scope, $state, Planner) {
        var vm = this;
        
        vm.planners = [];

        loadAll();

        function loadAll() {
            Planner.query(function(result) {
                vm.planners = result;
            });
        }
    }
})();
