message Add {
    queryId: Int as uint64;
    amount: Int as uint32;
}

message Deploy{
    queryId: Int as uint64;
}

message DeployOk{
    queryId: Int as uint64;
}

trait Deployable {
    receive(msg: Deploy){
        self.reply(DeployOk{queryId: msg.queryId}.toCell())
    }
}

contract DeployableCounter with Deployable {
    id: Int as uint32;
    counter: Int as uint32;

    init(id: Int) {
        self.id = id;
        self.counter = 0;
    }

    receive(msg: Add) {
        self.counter = (self.counter + msg.amount);
    }

    get fun counter(): Int {
        return self.counter;
    }

    get fun id(): Int {
        return self.id;
    }
}
