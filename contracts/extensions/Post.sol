// SPDX-License-Identifier: GPL-3.0-only
/*
    Author  : Javier Guajardo
    Github  : https://github.com/ethereumchile
    Twitter : @ethereumchile
    Website : https://ethereumchile.cl
    Date    : 03/12/2021
*/

pragma solidity >=0.7.0<=0.9.0;

import "./User.sol";

contract PostContract is UserContract {

    struct Post {
        string title;
        string content;
        uint datePublication;
        bool isPublished;
        address author;
    }

    struct PostReport {
        string reason;
        address author;
        uint postNumber;
        uint date;
    }

    PostReport[] postReports;
    uint postsCounter = 0;
    mapping(uint => Post) public post;
    mapping(uint => mapping(address => bool)) public postLikesCounter;
    mapping(address => mapping(uint => bool)) public postsLikedByUser;

    modifier onlyActivePost(uint number) {
        require(post[number].isPublished, "Post doesn't exist or deactivated");
        _;
    }

    function createPost(string memory title, string memory content) public onlyActiveUser(msg.sender) returns (bool) {
        Post memory newPost;
        newPost.title = title;
        newPost.content = content;
        newPost.datePublication = block.timestamp;
        newPost.isPublished = true;
        newPost.author = msg.sender;
        postsCounter++;
        post[postsCounter] = newPost;
        user[msg.sender].postCounter++;
        return true;
    }

    function likePost(uint number) public onlyActiveUser(msg.sender) onlyActivePost(number) returns (bool) {
        require(!postsLikedByUser[msg.sender][number]);
        postsLikedByUser[msg.sender][number] = true;
        postLikesCounter[number][msg.sender] = true;
        return true;
    }

    function dislikePost(uint number) public onlyActiveUser(msg.sender) onlyActivePost(number) returns (bool) {
        require(postsLikedByUser[msg.sender][number]);
        delete postsLikedByUser[msg.sender][number];
        delete postLikesCounter[number][msg.sender];
        return true;
    }

    function reportPost(uint number, string memory reason) public onlyActiveUser(msg.sender) onlyActivePost(number) returns (bool) {
        PostReport memory report;
        report.author = post[number].author;
        report.postNumber = number;
        report.reason = reason;
        postReports.push(report);
        return true;
    }

}