import {
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("Nft", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployNftContract() {
        const name = "Dwarves Foundation"
        const symbol = "DF"
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await hre.ethers.getSigners();

        const Attribute = await hre.ethers.getContractFactory("Attributes");
        const attribute = await Attribute.deploy();

        const Nft = await hre.ethers.getContractFactory("Nft");
        const nft = await Nft.deploy(name, symbol, owner.address, attribute.target);

        const AttributeOther = await hre.ethers.getContractFactory("Attributes");
        const attributeOther = await AttributeOther.deploy();

        return { nft, owner, otherAccount,attributeOther };
    }

    describe("Deployment",  function () {
        it("Check mint nft", async function () {
            const { nft, owner, otherAccount} = await loadFixture(deployNftContract);
            await nft.mint(otherAccount.address, 1)
            expect(await nft.totalMaxSupplyOfItem(1)).to.equal(1);
        });

        it("update other attribute ", async function () {
            const { nft, owner, otherAccount, attributeOther} = await loadFixture(deployNftContract);
            await nft.mint(otherAccount.address, 1)
            expect(await nft.totalMaxSupplyOfItem(1)).to.equal(1);
            await nft.setNewAttribute(attributeOther.target)
            expect(await nft.totalMaxSupplyOfItem(1)).to.equal(0);
        });

    });

});
