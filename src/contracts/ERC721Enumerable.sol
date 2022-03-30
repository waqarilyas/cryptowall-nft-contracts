// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {
    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokenIndex;

    function tokenByIndex(uint256 _index) external view returns (uint256) {
        require(_index < totalSupply(), "global index is out of bound");

        return _allTokensIndex[_index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256)
    {
        require(index < balanceOf(owner), "owner index is out of bound");
        return _ownedTokens[owner][index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokens[to].push(tokenId);
        _ownedTokenIndex[tokenId] = _ownedTokens[to].length;
    }

    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }
}
