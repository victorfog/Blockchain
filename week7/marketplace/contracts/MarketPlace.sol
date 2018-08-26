pragma solidity ^0.4.0;

contract MarketPlace {
    constructor() {}

    struct sFile {
        string Name;
        byte32 Hash;
        bytes32 SwormHash;
        uint Price;
        string Description;
        //todo категории
    }

    mapping(address => sFile[]) dbFile;

    address[] allVendorsThatHaveOneOrMoreFIleAtTheCurrentMoment; //todo

    function addFile(string _name, byte32 _Hash, byte32 _SwormHash, uint _Price, string _Description) {
        //todo проверка есть такой пользователь ?
        _fileCount = dbFile[msg.sender].length;
        if (_fileCount == 0) {
            _ownerIndex = allVendorsThatHaveOneOrMoreFIleAtTheCurrentMoment.push(msg.sender);
        }

        dbFile[msg.sender].push(sFile(_name, _Hash, _SwormHash, _Price, _Description));
    }

    function search(address _address, byte32 _SwormHash) view returns (uint, bool){
        sFile[] memory _searchSource = dbFile[_address];
        for (uint i = 0; i < _searchSource.length; i++) {
            if (_searchSource[i].SwormHash == _SwormHash) {
                return (i, true);
            }
        }

        return (0, false);
    }

    function list() public view returns(sFile[]) {
        sFile[] _allfiles;

        for (uint i = 0; i < allVendorsThatHaveOneOrMoreFIleAtTheCurrentMoment.length; i++) {
            _ownerAddress = allVendorsThatHaveOneOrMoreFIleAtTheCurrentMoment[i];
            _ownerFiles = dbFile[_ownerAddress];

            for (uint j = 0; j < _ownerFiles.length; j++) {
                _allfiles.push(_ownerFiles[j]);
            }
        }

        return _allfiles;
    }

}
