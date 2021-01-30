
import { expect } from 'chai';

describe('bar', () => {
    it('sync function returns true', () => {
        const result = true;
        expect(result).to.be.true;
    });

    it('async function returns true', async () => {
        const result = await true;
        expect(result).to.be.true;
    });
});
