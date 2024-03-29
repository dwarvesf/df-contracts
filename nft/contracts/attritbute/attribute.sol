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
        string icon;
        string consumables;
        string description;
    }


    function attribute_by_id(uint _id) public pure returns(attribute memory _attribute) {
        if (_id == 1) {
            return hammerOfThor();
        } else if (_id == 2) {
            return swordOfLoki();
        } else if (_id == 3) {
            return jarngreipr();
        } else if (_id == 4) {
            return gungnir();
        } else if (_id == 5) {
            return manteauOfVali();
        } else if (_id == 6) {
            return andvaranautRing();
        } else if (_id == 7) {
            return spindleOfNorns();
        } else if (_id == 8) {
            return bootsOfVidar();
        } else if (_id == 9) {
            return blessingOfOdin();
        } else if (_id == 10) {
            return voluspa();
        } else if (_id == 11) {
            return potionOfStrength();
        } else if (_id == 12) {
            return galdrar();
        } else if (_id == 13) {
            return fireMagic();
        } else if (_id == 14) {
            return anvil();
        } else if (_id == 15) {
            return goldenApple();
        } else if (_id == 16) {
            return crowFeathers();
        } else if (_id == 17) {
            return amanitaMuscaria();
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
        _attribute.icon = "";
        _attribute.description = "";
    }

    function swordOfLoki() public pure returns (attribute memory _attribute) {
        _attribute.id = 2;
        _attribute.tier = 1;
        _attribute.rarity = 5;
        _attribute.quantity = 1;
        _attribute.duration = 360;
        _attribute.boostStaking = 30;
        _attribute.consumables = "loki's sword";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function jarngreipr() public pure returns (attribute memory _attribute) {
        _attribute.id = 3;
        _attribute.tier = 1;
        _attribute.rarity = 4;
        _attribute.quantity = 2;
        _attribute.duration = 200;
        _attribute.boostStaking = 15;
        _attribute.consumables = unicode"járngreipr";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function gungnir() public pure returns (attribute memory _attribute) {
        _attribute.id = 4;
        _attribute.tier = 1;
        _attribute.rarity = 4;
        _attribute.quantity = 2;
        _attribute.duration = 200;
        _attribute.boostStaking = 15;
        _attribute.consumables = "gungnir";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function manteauOfVali() public pure returns (attribute memory _attribute) {
        _attribute.id = 5;
        _attribute.tier = 1;
        _attribute.rarity = 4;
        _attribute.quantity = 2;
        _attribute.duration = 200;
        _attribute.boostStaking = 15;
        _attribute.consumables = "vali's manteau";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function andvaranautRing() public pure returns (attribute memory _attribute) {
        _attribute.id = 6;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "andvaranaut ring";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function spindleOfNorns() public pure returns (attribute memory _attribute) {
        _attribute.id = 7;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "norns' spindle";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function bootsOfVidar() public pure returns (attribute memory _attribute) {
        _attribute.id = 8;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "vidar's boots";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function blessingOfOdin() public pure returns (attribute memory _attribute) {
        _attribute.id = 9;
        _attribute.tier = 2;
        _attribute.rarity = 4;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 15;
        _attribute.consumables = "odin's blessing";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function voluspa() public pure returns (attribute memory _attribute) {
        _attribute.id = 10;
        _attribute.tier = 2;
        _attribute.rarity = 3;
        _attribute.quantity = 3;
        _attribute.duration = 100;
        _attribute.boostStaking = 7;
        _attribute.consumables = unicode"völuspá";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function potionOfStrength() public pure returns (attribute memory _attribute) {
        _attribute.id = 11;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "potion of strength";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function galdrar() public pure returns (attribute memory _attribute) {
        _attribute.id = 12;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "galdrar";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function fireMagic() public pure returns (attribute memory _attribute) {
        _attribute.id = 13;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "fire magic";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function anvil() public pure returns (attribute memory _attribute) {
        _attribute.id = 14;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "anvil";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function goldenApple() public pure returns (attribute memory _attribute) {
        _attribute.id = 15;
        _attribute.tier = 3;
        _attribute.rarity = 3;
        _attribute.quantity = 4;
        _attribute.duration = 90;
        _attribute.boostStaking = 7;
        _attribute.consumables = "golden apple";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function crowFeathers() public pure returns (attribute memory _attribute) {
        _attribute.id = 16;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "crow feather";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function amanitaMuscaria() public pure returns (attribute memory _attribute) {
        _attribute.id = 17;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "amanita muscaria";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function oakLeaves() public pure returns (attribute memory _attribute) {
        _attribute.id = 18;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "oak leaves";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function leather() public pure returns (attribute memory _attribute) {
        _attribute.id = 19;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "leather";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function gold() public pure returns (attribute memory _attribute) {
        _attribute.id = 20;
        _attribute.tier = 4;
        _attribute.rarity = 2;
        _attribute.quantity = 5;
        _attribute.duration = 30;
        _attribute.boostStaking = 3;
        _attribute.consumables = "gold";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function iron() public pure returns (attribute memory _attribute) {
        _attribute.id = 21;
        _attribute.tier = 5;
        _attribute.rarity = 2;
        _attribute.quantity = 6;
        _attribute.duration = 15;
        _attribute.boostStaking = 3;
        _attribute.consumables = "iron";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function tools() public pure returns (attribute memory _attribute) {
        _attribute.id = 22;
        _attribute.tier = 5;
        _attribute.rarity = 2;
        _attribute.quantity = 6;
        _attribute.duration = 15;
        _attribute.boostStaking = 3;
        _attribute.consumables = "tools";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function oakPlanks() public pure returns (attribute memory _attribute) {
        _attribute.id = 23;
        _attribute.tier = 5;
        _attribute.rarity = 2;
        _attribute.quantity = 6;
        _attribute.duration = 15;
        _attribute.boostStaking = 2;
        _attribute.consumables = "oak planks";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function stone() public pure returns (attribute memory _attribute) {
        _attribute.id = 24;
        _attribute.tier = 5;
        _attribute.rarity = 1;
        _attribute.quantity = 7;
        _attribute.duration = 7;
        _attribute.boostStaking = 1;
        _attribute.consumables = "stone";
        _attribute.icon = "";
        _attribute.description = "";
    }

    function firewood() public pure returns (attribute memory _attribute) {
        _attribute.id = 25;
        _attribute.tier = 5;
        _attribute.rarity = 1;
        _attribute.quantity = 7;
        _attribute.duration = 7;
        _attribute.boostStaking = 1;
        _attribute.consumables = "firewood";
        _attribute.icon = "";
        _attribute.description = "";
    }
}
