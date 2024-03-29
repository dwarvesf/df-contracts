// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Attributes {
    struct attribute {
        uint8 id;
        uint8 tier;
        uint8 rarity;
        uint8 quantity;
        uint8 boostStaking;
        uint256 duration;
        string consumables;
    }


    function attribute_by_id(uint _id) public pure returns(attribute memory _attribute) {
        if (_id == 1) {
            return hammerOfThor();
        } else if (_id == 2) {
            return swordOfLoki();
        } else if (_id == 3) {
            return ironGloveOfThor();
        } else if (_id == 4) {
            return spearOfOdin();
        } else if (_id == 5) {
            return cloakOfVali();
        } else if (_id == 6) {
            return ringOfAndvari();
        } else if (_id == 7) {
            return spindleOfNorns();
        } else if (_id == 8) {
            return bootsOfVidar();
        } else if (_id == 9) {
            return blessingOfOdin();
        } else if (_id == 10) {
            return poemOfVoluspa();
        } else if (_id == 11) {
            return potionOfStrength();
        } else if (_id == 12) {
            return spell();
        } else if (_id == 13) {
            return fireMagic();
        } else if (_id == 14) {
            return anvil();
        } else if (_id == 15) {
            return goldenApple();
        } else if (_id == 16) {
            return crowFeathers();
        } else if (_id == 17) {
            return amanitaMushroom();
        } else if (_id == 18) {
            return oakLeaves();
        } else if (_id == 19) {
            return leather();
        } else if (_id == 20) {
            return gold();
        } else if (_id == 21) {
            return iron();
        } else if (_id == 22) {
            return tools();
        } else if (_id == 23) {
            return oakPlanks();
        } else if (_id == 24) {
            return stone();
        } else if (_id == 25) {
            return firewood();
        }
    }

    function hammerOfThor() public pure returns (attribute memory _attribute) {
        _attribute.id = 1;
        _attribute.tier = 1;
        _attribute.rarity = 5;
        _attribute.quantity = 1;
        _attribute.duration = 360;
        _attribute.boostStaking = 30;
        _attribute.consumables = "thor's hammer";
    }

    function swordOfLoki() public pure returns (attribute memory _attribute) {
        _attribute.id = 2;
        _attribute.tier = 1;
        _attribute.rarity = 5;
        _attribute.quantity = 1;
        _attribute.duration = 360;
        _attribute.boostStaking = 30;
        _attribute.consumables = "loki's sword";
    }

    function ironGloveOfThor() public pure returns (attribute memory _attribute) {
        _attribute.id = 3;
        _attribute.tier = 1;
        _attribute.rarity = 4;
        _attribute.quantity = 2;
        _attribute.duration = 200;
        _attribute.boostStaking = 15;
        _attribute.consumables = "thor's iron glove";
    }

    function spearOfOdin() public pure returns (attribute memory _attribute) {
        _attribute.id = 4;
        _attribute.tier = 1;
        _attribute.rarity = 4;
        _attribute.quantity = 2;
        _attribute.duration = 200;
        _attribute.boostStaking = 15;
        _attribute.consumables = "odin's spear";
    }

    function cloakOfVali() public pure returns (attribute memory _attribute) {
        _attribute.id = 5;
        _attribute.tier = 1;
        _attribute.rarity = 4;
        _attribute.quantity = 2;
        _attribute.duration = 200;
        _attribute.boostStaking = 15;
        _attribute.consumables = "vali's cloak";
    }

    function ringOfAndvari() public pure returns (attribute memory _attribute) {
        _attribute.id = 6;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "andvari's ring";
    }

    function spindleOfNorns() public pure returns (attribute memory _attribute) {
        _attribute.id = 7;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "norns' spindle";
    }

    function bootsOfVidar() public pure returns (attribute memory _attribute) {
        _attribute.id = 8;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "vidar's boots";
    }

    function blessingOfOdin() public pure returns (attribute memory _attribute) {
        _attribute.id = 9;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "odin's blessing";
    }

    function poemOfVoluspa() public pure returns (attribute memory _attribute) {
        _attribute.id = 10;
        _attribute.tier = 2;
        _attribute.rarity = 3;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 7;
        _attribute.consumables = "voluspa's poem";
    }

    function potionOfStrength() public pure returns (attribute memory _attribute) {
        _attribute.id = 11;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "potion of strength";
    }

    function spell() public pure returns (attribute memory _attribute) {
        _attribute.id = 12;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "spell";
    }

    function fireMagic() public pure returns (attribute memory _attribute) {
        _attribute.id = 13;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "fire magic";
    }

    function anvil() public pure returns (attribute memory _attribute) {
        _attribute.id = 14;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "anvil";
    }

    function goldenApple() public pure returns (attribute memory _attribute) {
        _attribute.id = 15;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "golden apple";
    }

    function crowFeathers() public pure returns (attribute memory _attribute) {
        _attribute.id = 16;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "crow feathers";
    }

    function amanitaMushroom() public pure returns (attribute memory _attribute) {
        _attribute.id = 17;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "amanita mushroom";
    }

    function oakLeaves() public pure returns (attribute memory _attribute) {
        _attribute.id = 18;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "oak leaves";
    }

    function leather() public pure returns (attribute memory _attribute) {
        _attribute.id = 19;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "leather";
    }

    function gold() public pure returns (attribute memory _attribute) {
        _attribute.id = 20;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "gold";
    }

    function iron() public pure returns (attribute memory _attribute) {
        _attribute.id = 21;
        _attribute.tier = 5;
        _attribute.rarity = 2;
        _attribute.quantity = 6;
        _attribute.duration = 15;
        _attribute.boostStaking = 3;
        _attribute.consumables = "iron";
    }

    function tools() public pure returns (attribute memory _attribute) {
        _attribute.id = 22;
        _attribute.tier = 5;
        _attribute.rarity = 2;
        _attribute.quantity = 6;
        _attribute.duration = 15;
        _attribute.boostStaking = 3;
        _attribute.consumables = "tools";
    }

    function oakPlanks() public pure returns (attribute memory _attribute) {
        _attribute.id = 23;
        _attribute.tier = 5;
        _attribute.rarity = 2;
        _attribute.quantity = 6;
        _attribute.duration = 15;
        _attribute.boostStaking = 2;
        _attribute.consumables = "oak planks";
    }

    function stone() public pure returns (attribute memory _attribute) {
        _attribute.id = 24;
        _attribute.tier = 5;
        _attribute.rarity = 1;
        _attribute.quantity = 7;
        _attribute.duration = 7;
        _attribute.boostStaking = 1;
        _attribute.consumables = "stone";
    }

    function firewood() public pure returns (attribute memory _attribute) {
        _attribute.id = 25;
        _attribute.tier = 5;
        _attribute.rarity = 1;
        _attribute.quantity = 7;
        _attribute.duration = 7;
        _attribute.boostStaking = 1;
        _attribute.consumables = "firewood";
    }
}
