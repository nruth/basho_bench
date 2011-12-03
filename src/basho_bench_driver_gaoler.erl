-module(basho_bench_driver_gaoler).
-export([new/1,
         run/4]).
-include("basho_bench.hrl").

new(_Id) ->
    case net_adm:ping('master@127.0.0.1') of
        pong ->
            io:format("connected~n", []);
        Error ->
            io:format("error connecting: ~p ~n", [erlang:get_cookie()])
    end,
    {ok, undefined}.

run(request, KeyGen, _ValueGen, State) ->
    Name = list_to_atom(KeyGen()),
    {resource, beer, {Name, _}} = 
        rpc:call('master@127.0.0.1', gaoler, request, [beer, Name]),
    {ok, State}.
