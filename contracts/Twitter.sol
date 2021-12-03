// SPDX-License-Identifier: GPL-3.0-only
/*
    Author  : Javier Guajardo
    Github  : https://github.com/ethereumchile
    Twitter : @ethereumchile
    Website : https://ethereumchile.cl
    Date    : 03/12/2021
*/

pragma solidity >=0.7.0<=0.9.0;

import "./extensions/User.sol";
import "./extensions/Post.sol";

contract Twitter is PostContract {

    address public admin;

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function deactivatePost(uint number) public onlyAdmin returns (bool) {
        require(post[number].isPublished);
        post[number].isPublished = false;
        return true;
    }

    function banUser(address account) public onlyAdmin returns (bool) {
        require(user[account].isRegistered && !user[account].isBanned);
        user[account].isBanned = true;
        user[account].dateBan = block.timestamp;
        return true;
    }

    function createAccountAsAdmin(address newUser, string memory nickname) public onlyAdmin returns (bool) {
        require(!user[newUser].isRegistered);
        user[newUser].nickname = nickname;
        user[newUser].isRegistered = true;
        user[newUser].dateRegistration = block.timestamp;
        return true;
    }


}