import "@stdlib/deploy";
// import "@stdlib/ownable";

message Add {
    queryId: Int as uint64;
    amount: Int as uint32;
}

trait Ownable {
    owner: Address;

    fun requireOwner(){
        nativeThrowUnless(123, sender() == self.owner);
    }

    get fun owner(): Address{
        return self.owner;
    }
}

message ChangeOwner{
    newOwner: Address;
}

trait OwnableTransferable with Ownable{
    owner: Address;

    receive(msg: ChangeOwner){
        self.requireOwner()
        self.owner = msg.newOwner;
    }
}

contract OwnableCounter with Deployable, OwnableTransferable {
    id: Int as uint32;
    counter: Int as uint32;
    owner: Address;

    init(id: Int) {
        self.id = id;
        self.counter = 0;
        self.owner = sender();
    }

    receive(msg: Add) {
        self.requireOwner();
        self.counter = (self.counter + msg.amount);
    }

    get fun counter(): Int {
        return self.counter;
    }

    get fun id(): Int {
        return self.id;
    }
}
