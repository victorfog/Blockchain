pragma solidity ^0.4.0;
//pragma experimental ABIEncoderV2;

contract MarketPlace {
    constructor() public {}

    struct sFile {
        string Name;
        bytes32 Hash;
        bytes32 SwarmHash;
        uint Price;
        string Description;
        uint FileID;
        uint SellerID;
        address Owner;
        //todo категории
    }

    struct oneOrder { // планируется для отслеживания подтверждения, что все получили чего хотели.
        //uint OrderID;
        uint FileID;
        address BayerAddress;
        bool OwnerApprove; // согласие завершение сделки со стороны владельца ресурса
        bool BayerApprove; // согласие завершение сделки со стороны покупателя
        uint FixPrise; // стоимость для фиксирования цены
        bool isPayed;


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
   // mapping(address => uint) deposit;

    oneOrder[] allOrders;
    mapping(uint => address) ownerOrdersID; //fixme записть заказов хромает надо сделать приятней, и ниже тоже
    mapping(uint => address) bayersOrdersID; //fixme да и тут

    address[] allVendorsAtTheCurrentMoment; // для проверки: есть ли такой продавец

    function addFile(string _name, bytes32 _Hash, bytes32 _SwarmHash, uint _Price, string _Description) public {
        uint _fileCount = sellerFileIDs[msg.sender].length;
        uint _SellerID;
        if (_fileCount == 0) {
            _SellerID = allVendorsAtTheCurrentMoment.push(msg.sender);
        } else {
            uint[] memory sellerFilesIDs = sellerFileIDs[msg.sender];
            uint sellerFirstFileID = sellerFilesIDs[0];
            _SellerID = dbFiles[sellerFirstFileID].SellerID;
        }

        uint _FileID = dbFiles.length;
        dbFiles.push(sFile(_name, _Hash, _SwarmHash, _Price, _Description, _FileID, _SellerID, msg.sender));
        sellerFileIDs[msg.sender].push(_FileID);
        //todo log file added event
    }

//    function list() public view returns(sFile[]) {
//        sFile[] memory _allfiles;
//        for (uint i = 0; i < dbFiles.length; i++) {
//            _allfiles.push(dbFiles[i]);
//        }
//        return _allfiles;
//
//    }

    mapping(address => uint) deposits;

    function createOrder(uint _FileID) public payable {
        // todo проверка ссуммы стоимости модели
        sFile memory BayFile = dbFiles[_FileID];
        require(BayFile.Price == msg.value);
//        deposits[msg.sender] += msg.value;
        uint _orderID = allOrders.push(oneOrder(_FileID, msg.sender, false, false, BayFile.Price, false));
        ownerOrdersID[_orderID];
        // fixme исправить !!!!
        bayersOrdersID[_orderID];
        // fixme исправить !!!!

    }


    function approveOrder(uint _orderID, bool _approve) public {
        oneOrder storage _order = allOrders[_orderID];
        sFile memory _fileInfo = dbFiles[_order.FileID];
        address _owner = _fileInfo.Owner;

        if (msg.sender == _order.BayerAddress) {
            _order.BayerApprove = _approve;
        }
        if (msg.sender == _owner) {
            _order.OwnerApprove = _approve; //todo не передумывать ????
        }
        //todo если она true вызвать closeOrder
         closeOrder(_orderID);
    }

    function closeOrder(uint _orderID) private {
        oneOrder storage _order = allOrders[_orderID];
        require(_order.isPayed == false, "the order has been already payed");

        uint amount = _order.FixPrise;
        address _owner = dbFiles[_order.FileID].Owner;
        require(_order.OwnerApprove == true);
        require(_order.BayerApprove == true);

        _order.isPayed = true;
        _owner.transfer(amount);
    }

    function searchOrder(uint _fileID) view public returns(uint) {
        oneOrder memory _order;
        for (uint i=0; i < allOrders.length; i++) {
            _order = allOrders[i];

            if (msg.sender != _order.BayerAddress) {
                continue;
            }

            if (_order.FileID == _fileID) {
                return i;
            }
            // кажись так цикл не остановить ((
        }
    }
}