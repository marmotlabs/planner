'use strict';

describe('Controller Tests', function() {

    describe('Recipe Management Detail Controller', function() {
        var $scope, $rootScope;
        var MockEntity, MockRecipe, MockIngredient, MockPlanner;
        var createController;

        beforeEach(inject(function($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            MockEntity = jasmine.createSpy('MockEntity');
            MockRecipe = jasmine.createSpy('MockRecipe');
            MockIngredient = jasmine.createSpy('MockIngredient');
            MockPlanner = jasmine.createSpy('MockPlanner');
            

            var locals = {
                '$scope': $scope,
                '$rootScope': $rootScope,
                'entity': MockEntity ,
                'Recipe': MockRecipe,
                'Ingredient': MockIngredient,
                'Planner': MockPlanner
            };
            createController = function() {
                $injector.get('$controller')("RecipeDetailController", locals);
            };
        }));


        describe('Root Scope Listening', function() {
            it('Unregisters root scope listener upon scope destruction', function() {
                var eventType = 'plannerApp:recipeUpdate';

                createController();
                expect($rootScope.$$listenerCount[eventType]).toEqual(1);

                $scope.$destroy();
                expect($rootScope.$$listenerCount[eventType]).toBeUndefined();
            });
        });
    });

});
