-module(basho_bench_driver_gaoler).
-export([new/1,
         run/4]).
-include("basho_bench.hrl").

-define (REMOTE, 'gaoler@lakka-1.it.kth.se').

new(Id) ->
    case net_adm:ping(?REMOTE) of
        pong ->
            io:format("Connected: ~p~n", [Id]);
        _Error ->
            io:format("error connecting: ~p ~n", [erlang:get_cookie()])
    end,
    {ok, undefined}.

% grab the lock, noop, then release it
run(acquire_release, _KeyGen, _ValueGen, State) ->    
    Client = self(),
    ok = rpc:call(?REMOTE, lock, acquire, [Client]),
    receive
        lock ->
            ok = rpc:call(?REMOTE, lock, release, [Client])
    end,
    {ok, State}.
