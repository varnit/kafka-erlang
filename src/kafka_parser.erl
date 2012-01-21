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
      0:64/integer,
      1048576:32/integer>>.

parse_response(B) ->
    %%<<L:32/integer, 0:8/integer, Check:32/integer, Msg:(L - 1 - 4)/binary, Rest/bitstring>> = B.
    ok.
