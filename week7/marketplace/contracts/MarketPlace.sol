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
        address BayerID;
        bool OwnerProof; // согласие завершение сделки со стороны владельца ресурса
        bool BayerProof; // согласие завершение сделки со стороны покупателя


        // берем из dbFiles[oneOrder.FileID]
        //        string Name;
        //        bytes32 Hash;
        //        bytes32 SwarmHash;
        //        uint Price;
        //        string Description;
        //
    }


    //  mapping(address => sFile[]) dbFile;
    sFile[] dbFiles;
    mapping(address => uint[]) sellerFileIDs;
    mapping(address => uint) deposit;

    oneOrder[] oneOrders;
    mapping(uint => address) ownerOrdersID; //fixme записть заказов хромает надо сделать приятней, и ниже тоже
    mapping(uint => address) bayersOrdersID; //fixme да и тут

    address[] allVendorsAtTheCurrentMoment; //todo

    function addFile(string _name, bytes32 _Hash, bytes32 _SwarmHash, uint _Price, string _Description) {
        uint _fileCount = sellerFileIDs[msg.sender].length;
        uint _SellerID;
        if (_fileCount == 0) {
            _SellerID = allVendorsAtTheCurrentMoment.push(msg.sender);
        } else {
            uint[] memory sellerFilesIDs = sellerFileIDs[msg.sender];
            uint sellerFirstFileID = sellerFilesIDs[0];
            _SellerID = dbFiles[sellerFirstFileID].SellerID;
        } //fixme

        uint _FileID = dbFiles.length;
        dbFiles.push(sFile(_name, _Hash, _SwarmHash, _Price, _Description, _FileID, _SellerID));
        sellerFileIDs.push(_FileID);
        //todo log file added event
    }

    function list() public view returns (sFile[]) {
        sFile[] memory _allfiles;
        for (uint i = 0; i < dbFiles.length; i++) {
            _allfiles.push(dbFiles[i]);
        }
        return _allfiles;

    }

    mapping(address => uint) deposits;

    function createOrder(uint _FileID) payable {
        // todo проверка ссуммы стоимости модели
        sFile BayFile = dbFiles[_FileID];
        require(BayFile.Price == msg.value);
        deposits[msg.sender] += msg.value;
        uint _orderID = oneOrders.push(oneOrder(_FileID, msg.sender, false, false));
        ownerOrdersID[_orderID]; // fixme исправить !!!!
        bayersOrdersID[_orderID];// fixme исправить !!!!

    }

    function approveOrder (uint _orderID, bool _approve){
        oneOrder _order = oneOrders[_orderID];
        sFile _fileInfo = dbFiles(_order.FileID);
        _fileInfo.SellerID;

        // fixme надо настроить мапы "ownerOrdersID" "bayersOrdersID" или еще как-то получить адрес владельца!!!!!!!

        if (msg.sender == _order.BayerID){
            oneOrders[_orderID]

        }else { (msg.sender == _)

        }


    }

}
