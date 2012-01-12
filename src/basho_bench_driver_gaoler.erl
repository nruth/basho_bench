%% Run with e.g. `GAOLER_REMOTE="vm_node@hostname" ./basho_bench examples/gaoler.config`
-module(basho_bench_driver_gaoler).
-export([new/1,
         run/4]).
-include("basho_bench.hrl").

remote() ->
    % remote address needed as atom() for net_adm:ping
    StringRemote = os:getenv("GAOLER_REMOTE"),
    list_to_atom(StringRemote).

new(Id) ->
    case net_adm:ping(remote()) of
        pong ->
            io:format("Connected: ~p~n", [Id]);
        _Error ->
            io:format("error connecting: ~p ~n", [erlang:get_cookie()])
    end,
    {ok, undefined}.

% grab the lock, noop, then release it
run(acquire_release, _KeyGen, _ValueGen, State) ->
    acquire_lock(),
    await_lock(),
    release_lock(),
    {ok, State}.

acquire_lock() ->
    ok = rpc:call(remote(), replica, request, [acquire,self()]).

await_lock() ->
    receive lock -> lock end.

release_lock() ->
    ok = rpc:call(remote(), lock, release, [self()]).
