const { assert } = require('chai');
require('chai').use(require('chai-as-promised')).should();

const KryptoBird = artifacts.require("KryptoBird");

contract("KryptoBird", function (accounts) {
  let contract;

  before(async () => {
    contract = await KryptoBird.deployed();
  })

  describe('deployment & verification', async () => {
    it("deploys successfully", async () => {
      contract = await KryptoBird.deployed();
      const address = contract.address;

      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.notEqual(address, 0x0);
    });

    it("get contract name", async () => {
      const name = await contract.name();
  
      assert.equal(name, 'KryptoBird');
    });

    it("get contract symbol", async () => {
      const symbol = await contract.symbol();
  
      assert.equal(symbol, 'KBIRDZ');
    });
  })

  describe('minting & indexing', async () => {
    let totalMint = 3, expectedResult = [];

    it(`minting ${totalMint} tokens`, async () => {
      // Mint tokens equivalent to the totalMint
      for (let i = 0; i < totalMint; i++) {
        const elementResult = await contract.mint(`JET${i}`);
        const elementEvent = elementResult.logs[0].args;
				expectedResult.push(`JET${i}`);

        // Success
        assert.equal(elementEvent._from, '0x0000000000000000000000000000000000000000','contact _from');
        assert.equal(elementEvent._to, accounts[0], 'contract _to');

        // Failure
        await contract.mint(`JET${i}`).should.be.rejected;
      }

      // Get contract totalsupply
      const supplyResult = await contract.totalSupply();

      assert.equal(supplyResult, totalMint);
    })

    it('list minted KryptoBirdz', async () => {
      let kryptoBird, kryptoBirdz = [];
      
      for (let i = 1; i <= totalMint; i++) {
        kryptoBird = await contract.kryptoBirdz(i - 1);
        kryptoBirdz.push(kryptoBird);
      }

			assert.equal(kryptoBirdz.join(','), expectedResult.join(','));
    })
  })
});
