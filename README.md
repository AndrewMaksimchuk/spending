# Types anotation JSDoc
```
// @ts-check

/** @type {{ a: string, b: number }} */

/**
 * @param {string}  p1
 * @return {string}
 */

  /**
 * @typedef {object} SpecialType - creates a new type named 'SpecialType'
 * @property {string} prop1
 * @property {number} prop2
 * @property {number=} prop3 - an optional  property
 */

/** @typedef {{ prop1: string, prop2: string, prop3?: number }} SpecialType */
/** @typedef {(data: string, index?: number) => boolean} Predicate */

/** @private */
/** @public */
/** @protected */
/** @readonly */
/** @implements {Print} */

```