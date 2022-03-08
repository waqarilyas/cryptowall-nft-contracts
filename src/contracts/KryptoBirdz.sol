// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC712Connector.sol";

contract KryptoBird is ERC721Connector {
    string[] public KryptoBirdz;
    mapping(string => bool) _kryptoBirdzExists;

    constructor() ERC721Connector("KryptoBird", "KBIRDZ") {}

    function mint(string memory _kryptobird) public {
        require(
            !_kryptoBirdzExists[_kryptobird],
            "KryptoBird: kryptobird already exists"
        );

        KryptoBirdz.push(_kryptobird);
        uint256 _id = KryptoBirdz.length - 1;
        _kryptoBirdzExists[_kryptobird] = true;
        _mint(msg.sender, _id);
    }
}
