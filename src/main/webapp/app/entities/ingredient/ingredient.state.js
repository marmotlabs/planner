(function() {
    'use strict';

    angular
        .module('plannerApp')
        .config(stateConfig);

    stateConfig.$inject = ['$stateProvider'];

    function stateConfig($stateProvider) {
        $stateProvider
        .state('ingredient', {
            parent: 'entity',
            url: '/ingredient?page&sort&search',
            data: {
                authorities: ['ROLE_USER'],
                pageTitle: 'plannerApp.ingredient.home.title'
            },
            views: {
                'content@': {
                    templateUrl: 'app/entities/ingredient/ingredients.html',
                    controller: 'IngredientController',
                    controllerAs: 'vm'
                }
            },
            params: {
                page: {
                    value: '1',
                    squash: true
                },
                sort: {
                    value: 'id,asc',
                    squash: true
                },
                search: null
            },
            resolve: {
                pagingParams: ['$stateParams', 'PaginationUtil', function ($stateParams, PaginationUtil) {
                    return {
                        page: PaginationUtil.parsePage($stateParams.page),
                        sort: $stateParams.sort,
                        predicate: PaginationUtil.parsePredicate($stateParams.sort),
                        ascending: PaginationUtil.parseAscending($stateParams.sort),
                        search: $stateParams.search
                    };
                }],
                translatePartialLoader: ['$translate', '$translatePartialLoader', function ($translate, $translatePartialLoader) {
                    $translatePartialLoader.addPart('ingredient');
                    $translatePartialLoader.addPart('global');
                    return $translate.refresh();
                }]
            }
        })
        .state('ingredient-detail', {
            parent: 'entity',
            url: '/ingredient/{id}',
            data: {
                authorities: ['ROLE_USER'],
                pageTitle: 'plannerApp.ingredient.detail.title'
            },
            views: {
                'content@': {
                    templateUrl: 'app/entities/ingredient/ingredient-detail.html',
                    controller: 'IngredientDetailController',
                    controllerAs: 'vm'
                }
            },
            resolve: {
                translatePartialLoader: ['$translate', '$translatePartialLoader', function ($translate, $translatePartialLoader) {
                    $translatePartialLoader.addPart('ingredient');
                    return $translate.refresh();
                }],
                entity: ['$stateParams', 'Ingredient', function($stateParams, Ingredient) {
                    return Ingredient.get({id : $stateParams.id}).$promise;
                }]
            }
        })
        .state('ingredient.new', {
            parent: 'ingredient',
            url: '/new',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/ingredient/ingredient-dialog.html',
                    controller: 'IngredientDialogController',
                    controllerAs: 'vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        entity: function () {
                            return {
                                quantity: null,
                                id: null
                            };
                        }
                    }
                }).result.then(function() {
                    $state.go('ingredient', null, { reload: true });
                }, function() {
                    $state.go('ingredient');
                });
            }]
        })
        .state('ingredient.edit', {
            parent: 'ingredient',
            url: '/{id}/edit',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/ingredient/ingredient-dialog.html',
                    controller: 'IngredientDialogController',
                    controllerAs: 'vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        entity: ['Ingredient', function(Ingredient) {
                            return Ingredient.get({id : $stateParams.id}).$promise;
                        }]
                    }
                }).result.then(function() {
                    $state.go('ingredient', null, { reload: true });
                }, function() {
                    $state.go('^');
                });
            }]
        })
        .state('ingredient.delete', {
            parent: 'ingredient',
            url: '/{id}/delete',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/ingredient/ingredient-delete-dialog.html',
                    controller: 'IngredientDeleteController',
                    controllerAs: 'vm',
                    size: 'md',
                    resolve: {
                        entity: ['Ingredient', function(Ingredient) {
                            return Ingredient.get({id : $stateParams.id}).$promise;
                        }]
                    }
                }).result.then(function() {
                    $state.go('ingredient', null, { reload: true });
                }, function() {
                    $state.go('^');
                });
            }]
        });
    }

})();
