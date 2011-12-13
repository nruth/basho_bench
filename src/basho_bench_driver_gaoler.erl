-module(basho_bench_driver_gaoler).
-export([new/1,
         run/4]).
-include("basho_bench.hrl").

new(Id) ->
    case net_adm:ping('gaoler@lakka-1.it.kth.se') of
        pong ->
            io:format("Connected: ~p~n", [Id]);
        Error ->
            io:format("error connecting: ~p ~n", [erlang:get_cookie()])
    end,
    {ok, undefined}.

run(request, _KeyGen, _ValueGen, State) ->    
    MasterHost = 'gaoler@lakka-1.it.kth.se',
    Client = self(),
    ok = rpc:call(MasterHost, centralised_lock, acquire, [Client]),
    receive
        lock ->
            ok = rpc:call(MasterHost, centralised_lock, release, [Client])
    end,
    {ok, State}.
