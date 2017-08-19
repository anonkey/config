import angular from 'angular';

import template from './template.html';
const COMPONANT_NAME = '##NAME##Container';

const config = ($stateProvider) => {
  $stateProvider
  .state('container.##NAME##', {
    url: 'notifications',
    views: {
      container: {
        template,
        controllerAs: COMPONANT_NAME,
        controller: Ctrl,
      }
    }
  });
};

export class Ctrl {
  constructor(##ARGS##) {
  }

}


angular.module(COMPONANT_NAME, [])
.config(config);

export default COMPONANT_NAME;
