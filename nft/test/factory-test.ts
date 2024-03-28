import {
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("NFTFactory", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployFactory() {
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await hre.ethers.getSigners();

        const Attribute = await hre.ethers.getContractFactory("Attributes");
        const attribute = await Attribute.deploy();

        const Factory = await hre.ethers.getContractFactory("NFTFactory");
        const factory = await Factory.deploy();

        return { factory, owner, otherAccount, attribute};
    }

    describe("Deployment",  function () {
        it("should create valid nf ", async function () {
            const name = "Dwarves Foundation"
            const symbol = "DF"
            const { factory, owner, otherAccount, attribute} = await loadFixture(deployFactory);
            await factory.createNft(name, symbol, owner.address, attribute.target)
            const zeroAddress = "0x0000000000000000000000000000000000000000"
            expect(await factory.nftArray(0)).to.not.equal(zeroAddress);

            const nftContractAddress = await factory.nftArray(0);
            const nft = await hre.ethers.getContractAt("Nft", nftContractAddress);
            await nft.mint(otherAccount.address, 100)
            expect(await nft.totalMaxSupplyOfToken()).to.equal(1);
        });

    });

});
