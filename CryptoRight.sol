pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
import "./ICryptoRight.sol";

contract CryptoRight is ICryptoRight {
        
    using Counters for Counters.Counter;

    Counters.Counter copyright_ids;

    struct Work {
        address owner;
        string uri;
    }    
    
    event Copyright(uint copyright_id, address owner, string reference_uri);
    event OpenSource(uint copyright_id, string reference_uri);
    event Transfer(uint copyright_id, address new_owner);
    
    modifier onlyCopyRightOwner(uint copyright_id) {
        require(copyrights[copyright_id].owner == msg.sender,
        "You don't have permission to alter this copyright");
        
        _;
    }

    // function copyrights(uint copyright_id) external returns(IWork memory);
    mapping(uint => Work) public copyrights;
    
    function copyrightWork(string memory reference_uri) public {
        //generates a new copyright_id of type uint and maps it to given
        //Work struct containing associated copyright owner and uri
        copyright_ids.increment();
        uint copyright_id = copyright_ids.current();
        
        copyrights[copyright_id] = Work(msg.sender, reference_uri);
        //must fire the Copyright event
        emit Copyright(copyright_id, msg.sender, reference_uri);
    }
    
    function openSourceWork(string memory reference_uri) public {
    //generates a new copyright_id of type uint  and maps it to a given uri by calling copyright_uri
        copyright_ids.increment();
        uint copyright_id = copyright_ids.current();
        
        copyrights[copyright_id] = Work(address(0), reference_uri);
    
    //fire OpenSource event 
        emit OpenSource(copyright_id, reference_uri);
    }
    function transferCopyrightOwnership(uint copyright_id, address new_owner) 
    public onlyCopyRightOwner(copyright_id){
        //remaps a given copyright_id to a new copyright owner. This function must only 
        //be callable by the address of the owner of the given copyright_id
        
        copyrights[copyright_id].owner = new_owner;
        
        emit Transfer(copyright_id, new_owner);
    } 
    
    function renounceCopyrightOwnership(uint copyright_id) 
    public onlyCopyRightOwner(copyright_id) {
        // Re-maps a given copyright_id to the 0x__ address in order to 
        //"open source" the copyright and prevent anyone from modifying it
        //Function must only be callable by address of owner of given copyright_id
        transferCopyrightOwnership(copyright_id, address(0));

        emit OpenSource(copyright_id, copyrights[copyright_id].uri);
    }

}
