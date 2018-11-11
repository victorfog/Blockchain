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

    }

    enum statusDisput {empty,exist,close}

    struct oneOrder {// планируется для отслеживания подтверждения, что все получили чего хотели.
        //uint OrderID;
        uint FileID;
        address BayerAddress;
        bool OwnerApprove; // согласие завершение сделки со стороны владельца ресурса
        bool BayerApprove; // согласие завершение сделки со стороны покупателя
        uint FixPrise; // стоимость для фиксирования цены
        bool IsPayed;
        statusDisput ExistDisput;
        uint DisputID;// id спора

        // берем из dbFiles[oneOrder.FileID]
        //        string Name;
        //        bytes32 Hash;
        //        bytes32 SwarmHash;
        //        uint Price;
        //        string Description;

    }

    struct arbitrator {
        address arbitratorAddress;
        // uint ID;
        uint DisputCount;
        uint Rating;
        uint Deposit; ///всю инфу хранитьтут мапинг по адресу на все данные арбитра
        bool Exist;
        //
    }


    struct disput {//todo: структура споров в массиве и id спора записывать продавцу
        uint DateCreateDisput;
        address WhoCreateDisput;
        string Complaint; //суть притензии
        string AnswerComplaint; // ответочка
        bool ConsentOwner;
        bool ConsentBayer;
        bool CallArbitr;
        string arbirtatorComment;
        uint arbitr1;
        bytes32 arbitr1vote; // кто из арбитров 1 2 3
        uint arbitr2;
        bytes32 arbitr2vote;
        uint arbirt3;
        bytes32 arbitr3vote;
    }
    // fixme насморк замучил немогу, только и бегаю до ванны и обратно 5 утра поеду в аптеку ((((
    //mapping(address=>uint[]) arbitrationDisputs; // не уверен что эир мне надо

    event NewFile(string _name, bytes32 _Hash, bytes32 _SwarmHash, uint _Price,
        string _Description, uint _FileID, uint _SellerID, address _owner);

    //  mapping(address => sFile[]) dbFile;
    sFile[] dbFiles;
    mapping(address => uint[]) sellerFileIDs;
    //mapping(uint => arbitrator[]) arbitratorDB; //ID арбитра на структуру с всеми данными по ниму
    // address[] arbitratorID; //массив адресов арбитров номер - адрес
    // mapping(address => uint) deposit;

    oneOrder[] allOrders;
    arbitrator[] allArbitrator; //арбитры
    mapping(uint => address) ownerOrdersID;
    mapping(uint => address) bayersOrdersID;
    mapping(address => uint) arbitratorID;
    mapping(uint => disput) allDisput;


    //disput[] allDisput; //сюда будем заносить споры fixme: переделать на mapping uint - > disput ( где uint orderID )
    //todo (возможно создать структуру покупателя с занесением информации о спорах)

    //mapping //идея заключается в сохранении номерСпора=>адбитры


    address[] allVendorsAtTheCurrentMoment; // для проверки: есть ли такой продавец
    // todo при создании файла нужно внести депозит
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


    event EventCreateOrder(uint _FileID, uint _orderID, uint _price);

    function createOrder(uint _FileID) public payable {
        sFile memory BayFile = dbFiles[_FileID];
        require(dbFiles.length >= _FileID, "Файл с указанным ID не существует");
        require(BayFile.Price <= msg.value, "given money should be greater than the price");
        uint _orderID = allOrders.push(oneOrder(_FileID, msg.sender, false, false, BayFile.Price, false, statusDisput.empty , 0)) - 1;
        //0- статус спора; 0-ID спора
        ownerOrdersID[_orderID];
        bayersOrdersID[_orderID];
        emit EventCreateOrder(_FileID, _orderID, BayFile.Price);
    }

    event eventApproveOrder(bool _owner, bool bayer, string statusTransaktion);

    function approveOrder(uint _orderID, bool _approve) public {
        require(allOrders.length >= _orderID, "given unexisted orderID");
        //todo проверка открытого спора

        oneOrder storage _order = allOrders[_orderID];
        sFile memory _fileInfo = dbFiles[_order.FileID];
        address _owner = _fileInfo.Owner;
        require(msg.sender == _order.BayerAddress || msg.sender == _fileInfo.Owner, "wrong buyer or seller address");

        if (msg.sender == _order.BayerAddress) {
            _order.BayerApprove = _approve;
            emit eventApproveOrder(_order.OwnerApprove, _order.BayerApprove, "no transaction");
        }
        if (msg.sender == _owner) {
            _order.OwnerApprove = _approve;
            emit eventApproveOrder(_order.OwnerApprove, _order.BayerApprove, "no transaction");
        }
        // если она true вызвать closeOrder
        if (_order.OwnerApprove == true && _order.BayerApprove == true) {
            closeOrder(_orderID);
            emit eventApproveOrder(_order.OwnerApprove, _order.BayerApprove, "Transaction");
        }

    }

    function closeOrder(uint _orderID) private {
        oneOrder storage _order = allOrders[_orderID];
        require(_order.IsPayed == false, "the order has been already payed");

        uint amount = _order.FixPrise;
        address _owner = dbFiles[_order.FileID].Owner;

        if (_order.OwnerApprove == true && _order.BayerApprove == true) {
            _order.IsPayed = true;
            _owner.transfer(amount);
        }
    }

    function searchOrder(uint _fileID) view public returns (uint) {
        oneOrder memory _order;
        for (uint i = 0; i < allOrders.length; i++) {
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

    function canselOrder(uint _orderID) public {//todo создать функцию отмена заказа
        oneOrder storage _order = allOrders[_orderID];
        require(_order.OwnerApprove == false && _order.BayerApprove == false);
        require(_order.IsPayed == false, "the order has been already payed");
        require(_order.ExistDisput != statusDisput.exist);
        address _bayerAddress = _order.BayerAddress;
        require(_bayerAddress == msg.sender);
        uint amount = _order.FixPrise;
        _order.IsPayed = true;
        _bayerAddress.transfer(amount);
        emit eventApproveOrder(_order.OwnerApprove, _order.BayerApprove, "Transaction");

    }

    uint constant minArbitorDeposit = 10;

    function addDepositArbitrator() public payable { // нужен тест
        uint _ID1 = arbitratorID[msg.sender];
        require(allArbitrator[_ID1].Exist == true);
        allArbitrator[_ID1].Deposit += msg.value;
    }

    function becomeANarbitrator() public payable { //нужен тетт
        require(minArbitorDeposit <= msg.value);
        arbitratorID[msg.sender] = newArbitrator(msg.sender, msg.value);
    }

    function newArbitrator(address arbitr, uint _deposit) private returns (uint) { //тужен тест
        return allArbitrator.push(arbitrator({
            arbitratorAddress : arbitr,
            Deposit : _deposit,
            DisputCount : 0,
            Rating : 0,
            Exist : true
            })) - 1;
    }

    event createDisputEvent(uint _orderID, string _complaint, address _owner, address _bayer); //нужен тест

    function createDisput(uint _orderID, string _complaint) public {
        oneOrder storage _order = allOrders[_orderID];
        sFile storage _fileInfo = dbFiles[_order.FileID];
        require(_order.BayerAddress == msg.sender || _fileInfo.Owner == msg.sender);
        require(_order.ExistDisput == statusDisput.empty);
        _order.ExistDisput = statusDisput.exist;
        allDisput[_orderID] = disput({
            DateCreateDisput: now,
            WhoCreateDisput: msg.sender,
            Complaint: _complaint,
            AnswerComplaint: "",
            ConsentOwner: false,
            ConsentBayer: false,
            CallArbitr: false,
            arbirtatorComment:"",
            arbitr1: 0 //fixme: надо настроить на пустой параметр или адрес контракта или владельца ресурса.
            arbitr1vote: empty,
            arbitr2: 0,
            arbitr2vote: empty,
            arbirt3: 0,
            arbitr3vote: empty
            });

        //todo обращаемся к базе арбитров и назначаем 3х красавцев
    }

    function callArbitrator (uint _orderID, string _comments) public { //нужен тест
        disput storage _disput = allDisput[_orderID];
        require(_disput.CallArbitr == false);
        require(_disput.DateCreateDisput + 10 days < now);
        _disput.arbitr1 = 0;
        _disput.arbirtatorComment = _comments;
        _disput.CallArbitr = true;

    }

    function setArbitr (uint _orderID) public returns(uint){ ///Нужен выбор арбитров
        uint _who; //fixme переделать на вызов функции рандомного выбора арбитров
        disput storage _disput = allDisput[_orderID];
        _disput.arbitr1 = _who; //какой-то бред нуден или номер арбитра из массива или его адрес и мап с индексами
        _disput.arbitr2 = _who;
        _disput.arbitr3 = _who;

    }





// fixme голосование ____ отметка все что ниже надо редактировать
// fixme

   // structVoting voting; // не нужна вместо нее все в disput
//    mapping(bool => address[]) votes;// старая проверка на произведено голосование или нет //fixme на
//    mapping(address => bool) usersDb;// todo: в мапинге надо хранить хеш голосов
//    mapping(bytes32 => address) hashBd;
//
//    event XXX(uint256);
//    event voteX(bool _vote, bytes32 _word);


    function vote(bytes32 _voteHash) public {
        require(voting.startDate <= now);
        require(voting.endDate >= now);
        require(usersDb[msg.sender] != true);

        usersDb[msg.sender] = true; // помечаем кто проголосовал
        hashBd[_voteHash] = msg.sender;
    }

    function hashVote(bool _vote, bytes32 _word) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_vote, _word));
    }

    function openvote(bool _vote, bytes32 _word) public {
        require(voting.endDate <= now);
        require(usersDb[msg.sender]);

        if (hashBd[hashVote(_vote, _word)] == msg.sender){
            votes[_vote].push(msg.sender);
        }
    }

    function stats() public view returns (uint, uint) {
        address[] memory _arrayVotesNo = votes[false];
        address[] memory _arrayVotesYes = votes[true];
        uint no = _arrayVotesNo.length;
        uint yes = _arrayVotesYes.length;

        return (no, yes);

    }
}