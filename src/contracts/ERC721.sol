// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

contract ERC721 is ERC165, IERC721 {
    // event Transfer(
    //     address indexed from,
    //     address indexed to,
    //     uint256 indexed tokenId
    // );
    // event Approval(
    //     address indexed owner,
    //     address indexed approved,
    //     uint256 indexed tokenId
    // );

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownedTokensCount;
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("_transferFrom(bytes4)")
            )
        );
    }

    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "owner query for non-existent tokens");
        return _ownedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        override
        returns (address)
    {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "owner query for non-existent tokens");
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        //requires that the address isn't zero
        require(to != address(0), "ERC721: minting to zero address");
        //require that token doesn't already exists
        require(!_exists(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _to != address(0),
            "Error - ERC721 Transfer to the zero address"
        );
        require(
            this.ownerOf(_tokenId) == _from,
            "Trying to transfer a token the address does not match owner"
        );

        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 tokenId) public {
        address owner = this.ownerOf(tokenId);
        require(_to != owner, "Error - Approval to current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of token"
        );
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(tokenId), "token does not exist");
        address owner = this.ownerOf(tokenId);

        // return (spender == owner || getApproved(tokenId) == spender);
        return (spender == owner);
        // return (0)
    }
}
