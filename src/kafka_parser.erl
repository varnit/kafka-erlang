-module(kafka_parser).
-author('Knut Nesheim <knutin@gmail.com>').

-compile([export_all]).

-define(FETCH, 1).


fetch_request(Topic, Offset, MaxSize) ->
    TopicSize = size(Topic),

    RequestSize = 2 + 2 + TopicSize + 4 + 8 + 4,

    <<RequestSize:32/integer,
      ?FETCH:16/integer,
      TopicSize:16/integer,
      Topic/binary,
      0:32/integer,
      Offset:64/integer,
      MaxSize:32/integer>>.



parse_messages(Bs) ->
    parse_messages(Bs, []).

parse_messages(<<>>, Acc) ->
    lists:reverse(Acc);
parse_messages(<<L:32/integer, _/binary>> = B, Acc) when size(B) >= L - 1 - 4->
    Length = L - 1 - 4,
    <<_:32/integer, 0:8/integer, _Check:32/integer,
      Msg:Length/binary,
      Rest/bitstring>> = B,
    parse_messages(Rest, [Msg | Acc]).

