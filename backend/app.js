import express from 'express';
import Keycloak from 'keycloak-connect';
import cors from 'cors';

const app = express();
const port = 3000;

app.use(cors());

// Middleware configuration loaded from keycloak.json file.
const keycloak = new Keycloak({});

app.use(keycloak.middleware());

app.get('/public', (req, res) => {
  res.json({message: 'public'});
});

app.get('/regular', keycloak.protect(), (req, res) => {
  res.json({message: 'regular logged in user can see'});
});

app.get('/actorrole', keycloak.protect('realm:actor'), (req, res) => {
  res.json({message: 'secured, only Realm Role: actor can see'});
});

app.use('*', (req, res) => {
  res.send('Not found!');
});

app.listen(port, () => {
  console.log(`Listening on port ${port}.`);
});
