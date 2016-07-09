(function() {
    'use strict';

    angular
        .module('plannerApp')
        .config(stateConfig);

    stateConfig.$inject = ['$stateProvider'];

    function stateConfig($stateProvider) {
        $stateProvider
        .state('planner', {
            parent: 'entity',
            url: '/planner',
            data: {
                authorities: ['ROLE_USER'],
                pageTitle: 'plannerApp.planner.home.title'
            },
            views: {
                'content@': {
                    templateUrl: 'app/entities/planner/planners.html',
                    controller: 'PlannerController',
                    controllerAs: 'vm'
                }
            },
            resolve: {
                translatePartialLoader: ['$translate', '$translatePartialLoader', function ($translate, $translatePartialLoader) {
                    $translatePartialLoader.addPart('planner');
                    $translatePartialLoader.addPart('global');
                    return $translate.refresh();
                }]
            }
        })
        .state('planner-detail', {
            parent: 'entity',
            url: '/planner/{id}',
            data: {
                authorities: ['ROLE_USER'],
                pageTitle: 'plannerApp.planner.detail.title'
            },
            views: {
                'content@': {
                    templateUrl: 'app/entities/planner/planner-detail.html',
                    controller: 'PlannerDetailController',
                    controllerAs: 'vm'
                }
            },
            resolve: {
                translatePartialLoader: ['$translate', '$translatePartialLoader', function ($translate, $translatePartialLoader) {
                    $translatePartialLoader.addPart('planner');
                    return $translate.refresh();
                }],
                entity: ['$stateParams', 'Planner', function($stateParams, Planner) {
                    return Planner.get({id : $stateParams.id}).$promise;
                }]
            }
        })
        .state('planner.new', {
            parent: 'planner',
            url: '/new',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/planner/planner-dialog.html',
                    controller: 'PlannerDialogController',
                    controllerAs: 'vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        entity: function () {
                            return {
                                name: null,
                                date: null,
                                id: null
                            };
                        }
                    }
                }).result.then(function() {
                    $state.go('planner', null, { reload: true });
                }, function() {
                    $state.go('planner');
                });
            }]
        })
        .state('planner.edit', {
            parent: 'planner',
            url: '/{id}/edit',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/planner/planner-dialog.html',
                    controller: 'PlannerDialogController',
                    controllerAs: 'vm',
                    backdrop: 'static',
                    size: 'lg',
                    resolve: {
                        entity: ['Planner', function(Planner) {
                            return Planner.get({id : $stateParams.id}).$promise;
                        }]
                    }
                }).result.then(function() {
                    $state.go('planner', null, { reload: true });
                }, function() {
                    $state.go('^');
                });
            }]
        })
        .state('planner.delete', {
            parent: 'planner',
            url: '/{id}/delete',
            data: {
                authorities: ['ROLE_USER']
            },
            onEnter: ['$stateParams', '$state', '$uibModal', function($stateParams, $state, $uibModal) {
                $uibModal.open({
                    templateUrl: 'app/entities/planner/planner-delete-dialog.html',
                    controller: 'PlannerDeleteController',
                    controllerAs: 'vm',
                    size: 'md',
                    resolve: {
                        entity: ['Planner', function(Planner) {
                            return Planner.get({id : $stateParams.id}).$promise;
                        }]
                    }
                }).result.then(function() {
                    $state.go('planner', null, { reload: true });
                }, function() {
                    $state.go('^');
                });
            }]
        });
    }

})();
