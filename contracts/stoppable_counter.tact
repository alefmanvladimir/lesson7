import "@stdlib/deploy";
// import "@stdlib/stoppable";
import "@stdlib/ownable";

trait Stoppable with Ownable{
    owner: Address;
    stopped: Bool;

    receive("stop"){
        self.requireOwner();

        self.stopped = true;
        self.reply("stopped".asComment());
    }

    fun requireNotStopped() {
        require(!self.stopped, "Contract stopped");
    }

    fun requireStopped() {
        require(self.stopped, "Contract not stopped");
    }

    get fun stopped(): Bool{
        return self.stopped;
    }
}

trait Resumable with Stoppable {
    stopped: Bool;
    owner: Address;
    
    receive("resume"){
        self.requireOwner();
        self.requireStopped();
        self.stopped = false;
        self.reply("resumed".asComment());
    }
}

message Add {
    queryId: Int as uint64;
    amount: Int as uint32;
}

contract StoppableCounter with Deployable, Resumable {
    id: Int as uint32;
    counter: Int as uint32;
    stopped: Bool;

    init(id: Int) {
        self.id = id;
        self.counter = 0;
        self.stopped = false;
        self.owner = sender();
    }

    receive(msg: Add) {
        self.requireNotStopped();
        self.counter = (self.counter + msg.amount);
    }

    get fun counter(): Int {
        return self.counter;
    }

    get fun id(): Int {
        return self.id;
    }
}
