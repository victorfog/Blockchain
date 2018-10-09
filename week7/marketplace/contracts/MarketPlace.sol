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

    event NewFile(string _name, bytes32 _Hash, bytes32 _SwarmHash, uint _Price,
            string _Description, uint _FileID, uint _SellerID, address _owner);

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

        emit NewFile(_name, _Hash, _SwarmHash, _Price, _Description, _FileID, _SellerID, msg.sender);
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

    event EventCreateOrder(uint _FileID, uint _orderID, uint _price);

    function createOrder(uint _FileID) public payable {
        // todo проверка суммы стоимости модели
        sFile memory BayFile = dbFiles[_FileID];
        require(dbFiles.length >= _FileID, "Файл с указанным ID не существует");
        require(BayFile.Price <= msg.value, "given money should be greater than the price");
//      deposits[msg.sender] += msg.value;
        uint _orderID = allOrders.push(oneOrder(_FileID, msg.sender, false, false, BayFile.Price, false))-1;
        ownerOrdersID[_orderID];
        // fixme исправить !!!!!
        bayersOrdersID[_orderID];
        // fixme исправить !!!!!
        emit EventCreateOrder(_FileID, _orderID, BayFile.Price);
    }

    event eventApproveOrder(bool _owner, bool bayer, string statusTransaktion);

    function approveOrder(uint _orderID, bool _approve) public {
        require(allOrders.length >= _orderID, "given unexisted orderID");

        oneOrder storage _order = allOrders[_orderID];
        sFile memory _fileInfo = dbFiles[_order.FileID];
        address _owner = _fileInfo.Owner;
        require(msg.sender == _order.BayerAddress || msg.sender == _fileInfo.Owner, "wrong buyer or seller address");

        if (msg.sender == _order.BayerAddress) {
            _order.BayerApprove = _approve;
            emit eventApproveOrder(_order.OwnerApprove, _order.BayerApprove, "no transaction"); //todo Ты вчера остановился на написании события для проверки статуса транзакции
        }
        if (msg.sender == _owner) {
            _order.OwnerApprove = _approve; //todo не передумывать ????
            emit eventApproveOrder(_order.OwnerApprove, _order.BayerApprove, "no transaction");
        }
        //todo если она true вызвать closeOrder
        if(_order.OwnerApprove == true && _order.BayerApprove == true){
            closeOrder(_orderID);
            emit eventApproveOrder(_order.OwnerApprove, _order.BayerApprove, "Transaction");
        }

    }

    function closeOrder(uint _orderID) private {
        oneOrder storage _order = allOrders[_orderID];
        require(_order.isPayed == false, "the order has been already payed");

        uint amount = _order.FixPrise;
        address _owner = dbFiles[_order.FileID].Owner;

        if (_order.OwnerApprove == true && _order.BayerApprove == true) {
            _order.isPayed = true;
            _owner.transfer(amount);
        }
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