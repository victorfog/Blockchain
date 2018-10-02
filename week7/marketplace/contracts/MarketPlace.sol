pragma solidity ^0.4.0;
//pragma experimental ABIEncoderV2;

contract MarketPlace {
    constructor() {}

    struct sFile {
        string Name;
        bytes32 Hash;
        bytes32 SwarmHash;
        uint Price;
        string Description;
        uint FileID;
        uint SellerID;
        //todo категории
    }

    struct oneOrder {// планируется для отслеживания подтверждения, что все получили чего хотели.
        //uint OrderID;
        uint FileID;
        uint SellerID;
        uint BayerID;
        bool OwnerProof; // согласие завершение сделки со стороны владельца ресурса
        bool BayerProof; // согласие завершение сделки со стороны покупателя
        uint Amount; // сумма для перевода
    }


    mapping(address => sFile[]) dbFile;
    mapping(address => uint) deposit;
   //  mapping(uint => oneOrder[]) ordersDb; // гон я не смогу использовать так как не смогу получать длнну мапинга.

    oneOrder[] oneOrders;
    mapping(address => uint) ownerOrdersID;
    mapping(address => uint) bayersOrdersID;



    address[] allVendorsAtTheCurrentMoment; //todo

    function addFile(string _name, bytes32 _Hash, bytes32 _SwarmHash, uint _Price, string _Description) {
        uint _fileCount = dbFile[msg.sender].length;
        uint _SellerID;
        if (_fileCount == 0) {
            _SellerID = allVendorsAtTheCurrentMoment.push(msg.sender); //тебе нужны эта хрень
        } else {
            _SellerID = dbFile[msg.sender][0].SellerID;
        }

        uint _FileID = dbFile[msg.sender].length;
        dbFile[msg.sender].push(sFile(_name, _Hash, _SwarmHash, _Price, _Description, _FileID, _SellerID));
        //todo log file added event
    }


    function list() public view returns (sFile[]) {
        sFile[] memory _allfiles;

        for (uint i = 0; i < allVendorsAtTheCurrentMoment.length; i++) {
            address _ownerAddress = allVendorsAtTheCurrentMoment[i];
            sFile[] memory _ownerFiles = dbFile[_ownerAddress];

            for (uint j = 0; j < _ownerFiles.length; j++) {
                _allfiles.push(_ownerFiles[j]);
            }
        }

        return _allfiles;

    }

    function createOrder(address _addressSeller, uint _FileID ) payable {
        // todo проверка ссуммы стоимости модели
        oneOrders.push()

    }


}
