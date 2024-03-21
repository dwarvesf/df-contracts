const {expect} = require('chai');

describe('Soulbound', function () {
  let owner;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    const Soulbound = await ethers.getContractFactory('Soulbound');
    this.soulbound = await Soulbound.deploy("MyToken", "MTK", owner.address);

    // Mint token ID 1 to the owner
    await this.soulbound.safeMint(owner.address);
  });

  it("check the owner is correct", async function () {
    expect(await this.soulbound.ownerOf(0)).to.equal(owner.address);
  });

  it("should revert when trying to transfer via safeTransferFrom", async function () {
    const approve = this.soulbound.approve("0x000000000000000000000000000000000000dEaD", 1);
    await expect(this.soulbound["safeTransferFrom(address,address,uint256)"](
      owner.address, 
      "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5", 
      1 // token id
    )).to.be.reverted;
  });

  it("should revert when trying to transfer via transferFrom", async function () {
    const approve = this.soulbound.approve("0x000000000000000000000000000000000000dEaD", 1);
    await expect(this.soulbound["transferFrom(address,address,uint256)"](
      owner.address, 
      "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5", 
      1 // token id
    )).to.be.reverted;
  });
});
