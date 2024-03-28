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
            await nft.mint(otherAccount.address, 100)
            let attr = await nft.getTokenAttribute(1);
            console.log(attr);
            expect(await nft.totalMaxSupplyOfItem(attr.id)).to.equal(1);
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(2);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(3);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(4);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(5);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(6);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(7);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(8);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(9);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(10);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(11);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(12);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(13);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(14);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(15);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(16);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(17);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(18);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(19);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(20);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(21);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(22);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(23);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(24);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(25);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(26);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(27);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(28);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(29);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(30);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(31);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(32);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(33);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(34);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(35);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(36);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(37);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(38);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(39);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(40);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(41);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(42);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(43);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(44);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(45);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(46);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(47);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(48);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(49);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(50);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(51);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(52);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(53);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(54);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(55);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(56);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(57);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(58);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(59);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(60);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(61);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(62);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(63);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(64);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(65);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(66);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(67);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(68);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(69);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(70);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(71);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(72);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(73);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(74);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(75);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(76);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(77);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(78);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(79);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(80);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(81);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(82);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(83);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(84);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(85);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(86);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(87);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(88);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(89);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(90);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(91);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(92);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(93);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(94);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(95);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(96);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(97);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(98);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(99);
            console.log(attr)
            await nft.mint(otherAccount.address, 100)
            attr = await nft.getTokenAttribute(100);
            console.log(attr)
        });

        it("update other attribute ", async function () {
            const { nft, owner, otherAccount, attributeOther} = await loadFixture(deployNftContract);
            await nft.mint(otherAccount.address, 100)
            const attr = await nft.getTokenAttribute(1);
            await nft.setNewAttribute(attributeOther.target)
            expect(await nft.totalMaxSupplyOfItem(attr.id)).to.equal(0);
        });


        it("get token uri ", async function () {
            const { nft, owner, otherAccount, attributeOther} = await loadFixture(deployNftContract);
            await nft.setBaseURI("https://ipfs/df/")
            await nft.mint(otherAccount.address, 100)
            const attr = await nft.getTokenAttribute(1);
            expect(await nft.tokenURI(1)).to.equal("https://ipfs/df/" + attr.id.toString());
        });

    });

});
