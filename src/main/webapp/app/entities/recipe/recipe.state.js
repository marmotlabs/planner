(function() {
    'use strict';

    angular
        .module('plannerApp')
        .config(stateConfig);

    stateConfig.$inject = ['$stateProvider'];

    function stateConfig($stateProvider) {
        $stateProvider
        .state('recipe', {
            parent: 'entity',
            url: '/recipe',
            data: {
                authorities: ['ROLE_USER'],
                pageTitle: 'plannerApp.recipe.home.title'
            },
            views: {
                'content@': {
                    templateUrl: 'app/entities/recipe/recipes.html',
                    controller: 'RecipeController',
                    controllerAs: 'vm'
                }
            },
            resolve: {
                translatePartialLoader: ['$translate', '$translatePartialLoader', function ($translate, $translatePartialLoader) {
                    $translatePartialLoader.addPart('recipe');
                    $translatePartialLoader.addPart('category');
                    $translatePartialLoader.addPart('global');
                    return $translate.refresh();
                }]
            }
        })
        .state('recipe-detail', {
            parent: 'entity',
            url: '/recipe/{id}',
            data: {
                authorities: ['ROLE_USER'],
                pageTitle: 'plannerApp.recipe.detail.title'
            },
            views: {
                'content@': {
                    templateUrl: 'app/entities/recipe/recipe-detail.html',
                    controller: 'RecipeDetailController',
                    controllerAs: 'vm'
                }
            },
            resolve: {
                translatePartialLoader: ['$translate', '$translatePartialLoader', function ($translate, $translatePartialLoader) {
                    $translatePartialLoader.addPart('recipe');
                    $translatePartialLoader.addPart('category');
                    return $translate.refresh();
                }],
                entity: ['$stateParams', 'Recipe', function($stateParams, Recipe) {
                    return Recipe.get({id : $stateParams.id}).$promise;
                }]
            }
        })
        .state('recipe.new', {
            parent: 'recipe',
            url: '/new',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/recipe/recipe-dialog.html',
                    controller: 'RecipeDialogController',
                    controllerAs: 'vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        entity: function () {
                            return {
                                title: null,
                                description: null,
                                category: null,
                                activeRequiredTime: null,
                                picture: null,
                                portions: null,
                                id: null
                            };
                        }
                    }
                }).result.then(function() {
                    $state.go('recipe', null, { reload: true });
                }, function() {
                    $state.go('recipe');
                });
            }]
        })
        .state('recipe.edit', {
            parent: 'recipe',
            url: '/{id}/edit',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/recipe/recipe-dialog.html',
                    controller: 'RecipeDialogController',
                    controllerAs: 'vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        entity: ['Recipe', function(Recipe) {
                            return Recipe.get({id : $stateParams.id}).$promise;
                        }]
                    }
                }).result.then(function() {
                    $state.go('recipe', null, { reload: true });
                }, function() {
                    $state.go('^');
                });
            }]
        })
        .state('recipe.delete', {
            parent: 'recipe',
            url: '/{id}/delete',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/recipe/recipe-delete-dialog.html',
                    controller: 'RecipeDeleteController',
                    controllerAs: 'vm',
                    size: 'md',
                    resolve: {
                        entity: ['Recipe', function(Recipe) {
                            return Recipe.get({id : $stateParams.id}).$promise;
                        }]
                    }
                }).result.then(function() {
                    $state.go('recipe', null, { reload: true });
                }, function() {
                    $state.go('^');
                });
            }]
        });
    }

})();
