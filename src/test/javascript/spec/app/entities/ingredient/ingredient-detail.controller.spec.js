'use strict';

describe('Controller Tests', function() {

    describe('Ingredient Management Detail Controller', function() {
        var $scope, $rootScope;
        var MockEntity, MockIngredient, MockProduct, MockRecipe;
        var createController;

        beforeEach(inject(function($injector) {
            $rootScope = $injector.get('$rootScope');
            $scope = $rootScope.$new();
            MockEntity = jasmine.createSpy('MockEntity');
            MockIngredient = jasmine.createSpy('MockIngredient');
            MockProduct = jasmine.createSpy('MockProduct');
            MockRecipe = jasmine.createSpy('MockRecipe');
            

            var locals = {
                '$scope': $scope,
                '$rootScope': $rootScope,
                'entity': MockEntity ,
                'Ingredient': MockIngredient,
                'Product': MockProduct,
                'Recipe': MockRecipe
            };
            createController = function() {
                $injector.get('$controller')("IngredientDetailController", locals);
            };
        }));


        describe('Root Scope Listening', function() {
            it('Unregisters root scope listener upon scope destruction', function() {
                var eventType = 'plannerApp:ingredientUpdate';

                createController();
                expect($rootScope.$$listenerCount[eventType]).toEqual(1);

                $scope.$destroy();
                expect($rootScope.$$listenerCount[eventType]).toBeUndefined();
            });
        });
    });

});
