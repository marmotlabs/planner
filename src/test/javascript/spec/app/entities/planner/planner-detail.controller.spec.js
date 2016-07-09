'use strict';

describe('Controller Tests', function() {

    describe('Planner Management Detail Controller', function() {
        var $scope, $rootScope;
        var MockEntity, MockPlanner, MockUser, MockRecipe;
        var createController;

        beforeEach(inject(function($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            MockEntity = jasmine.createSpy('MockEntity');
            MockPlanner = jasmine.createSpy('MockPlanner');
            MockUser = jasmine.createSpy('MockUser');
            MockRecipe = jasmine.createSpy('MockRecipe');
            

            var locals = {
                '$scope': $scope,
                '$rootScope': $rootScope,
                'entity': MockEntity ,
                'Planner': MockPlanner,
                'User': MockUser,
                'Recipe': MockRecipe
            };
            createController = function() {
                $injector.get('$controller')("PlannerDetailController", locals);
            };
        }));


        describe('Root Scope Listening', function() {
            it('Unregisters root scope listener upon scope destruction', function() {
                var eventType = 'plannerApp:plannerUpdate';

                createController();
                expect($rootScope.$$listenerCount[eventType]).toEqual(1);

                $scope.$destroy();
                expect($rootScope.$$listenerCount[eventType]).toBeUndefined();
            });
        });
    });

});
