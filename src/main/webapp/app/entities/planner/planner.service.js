(function() {
    'use strict';
    angular
        .module('plannerApp')
        .factory('Planner', Planner);

    Planner.$inject = ['$resource', 'DateUtils'];

    function Planner ($resource, DateUtils) {
        var resourceUrl =  'api/planners/:id';

        return $resource(resourceUrl, {}, {
            'query': { method: 'GET', isArray: true},
            'get': {
                method: 'GET',
                transformResponse: function (data) {
                    if (data) {
                        data = angular.fromJson(data);
                        data.date = DateUtils.convertDateTimeFromServer(data.date);
                    }
                    return data;
                }
            },
            'update': { method:'PUT' }
        });
    }
})();
