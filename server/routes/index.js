// @ts-check
import express from 'express';

const router = express.Router();

router.get('/', function(req, res, next) {
  res.json({mess: 'hello'})
});

export default router;
