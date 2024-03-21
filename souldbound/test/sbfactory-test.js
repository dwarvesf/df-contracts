const {expect} = require('chai');

describe('SBFactory', function () {
  let owner;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    const Factory = await ethers.getContractFactory('SBFactory');
    this.factory = await Factory.deploy();

    await this.factory.createSoulbound("MySoulbound", "MSB", owner.address);
  });

  it("should create valid souldbound", async function () {
    const zeroAddress = "0x0000000000000000000000000000000000000000"
    expect(await this.factory.soulbounds(0)).to.not.equal(zeroAddress);

    const soulboundAddress = await this.factory.soulbounds(0);
    const Soulbound = await ethers.getContractFactory('Soulbound');
    const soulbound = Soulbound.attach(soulboundAddress);

    // Mint token ID 1 to the owner
    await soulbound.safeMint(owner.address);
    expect(await soulbound.ownerOf(0)).to.equal(owner.address);
  });

  it("should revert when trying to transfer via safeTransferFrom", async function () {
    await this.factory.createSoulbound("MySoulbound", "MSB", owner.address);
    const soulboundAddress = await this.factory.soulbounds(0);
    const Soulbound = await ethers.getContractFactory('Soulbound');
    const soulbound = await Soulbound.attach(soulboundAddress);

    // Mint token ID 1 to the owner
    await soulbound.safeMint(owner.address);
    expect(await soulbound.ownerOf(0)).to.equal(owner.address);
    const approve = soulbound.approve("0x000000000000000000000000000000000000dEaD", 1);

    await expect(soulbound["safeTransferFrom(address,address,uint256)"](
      owner.address, 
      "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5", 
      1 // token id
    )).to.be.reverted;
  });

  it("should revert when trying to transfer via transferFrom", async function () {
    await this.factory.createSoulbound("MySoulbound", "MSB", owner.address);
    const soulboundAddress = await this.factory.soulbounds(0);
    const Soulbound = await ethers.getContractFactory('Soulbound');
    const soulbound = await Soulbound.attach(soulboundAddress);

    // Mint token ID 1 to the owner
    await soulbound.safeMint(owner.address);
    expect(await soulbound.ownerOf(0)).to.equal(owner.address);
    const approve = soulbound.approve("0x000000000000000000000000000000000000dEaD", 1);

    await expect(soulbound["transferFrom(address,address,uint256)"](
      owner.address, 
      "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5", 
      1 // token id
    )).to.be.reverted;
  });
});

