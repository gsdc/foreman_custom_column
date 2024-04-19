import React from 'react';
import WelcomePage from './WelcomePage';

const routes = [
  {
    path: '/foreman_custom_column/welcome',
    exact: true,
    render: (props) => <WelcomePage {...props} />,
  },
];

export default routes;
