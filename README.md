# Erlang library for Kafka

Implemented in `kafka_consumer.erl` is a simple blocking Kafka consumer. Maybe more will follow.

## Example
```erlang

$ erl -pa ebin
Erlang R15B01 (erts-5.9.1) [source] [64-bit] [smp:4:4] [async-threads:0] [hipe] [kernel-poll:false]

Eshell V5.9.1  (abort with ^G)
1> {ok, C} = kafka_consumer:start_link("127.0.0.1", 9092, <<"test">>, 0, fun(T, O, N) -> io:format("Topic: ~p~noffset :~p~nnew offset: ~p~n", [T, O, N]) end).
{ok,<0.33.0>}

2> kafka_consumer:fetch(C).
Topic: <<"test">>
offset :0
new offset: 15
{ok,[<<"varnit">>]}
```
