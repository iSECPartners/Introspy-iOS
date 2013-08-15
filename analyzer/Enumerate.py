class Enumerate:
    def __init__(self, storage, info):
        self.traced_calls = storage
        self.infoz = self.enumerateInfo(info)

    def enumerateInfo(self, info):
	objects = []
        if info == "http":
            for call in self.traced_calls:
                if 'request' in call.argsAndReturnValue['arguments']:
                    objects.append(call.argsAndReturnValue['arguments']['request']['URL']['absoluteString'])
	elif info == "fileio":
            for call in self.traced_calls:
                if 'url' in call.argsAndReturnValue['arguments']:
                    objects.append(call.argsAndReturnValue['arguments']['url']['absoluteString'])
                if 'path' in call.argsAndReturnValue['arguments']:
                    objects.append(call.argsAndReturnValue['arguments']['path'])
        elif info == "keys":
            for call in self.traced_calls:
                if call.method == "SecItemAdd":
                    objects.append("{0} = {1}".format(call.argsAndReturnValue['arguments']['attributes']['acct'],
                        call.argsAndReturnValue['arguments']['attributes']['v_Data']))
                elif call.method == "SecItemUpdate":
                    objects.append("{0} = {1}".format(call.argsAndReturnValue['arguments']['query']['acct'],
                        call.argsAndReturnValue['arguments']['attributesToUpdate']['v_Data']))

        list = dict(map(None,objects,[])).keys()
        list.sort()
        for item in list:
            print item 
        return list
