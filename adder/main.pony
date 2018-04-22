use "time"

primitive Output
  fun addNumbers(env: Env, x: I64, y: I64) =>
    env.out.print(x.string() + " + " + y.string() + " = " + (x+y).string())

class iso Handler is StdinNotify

  let env: Env
  var arr: String val = ""
  let _timers: Timers = Timers
  let _timer: (Timer tag | None)

  new iso create(env': Env) =>
    env = env'
    let timer = Timer(
      object iso is TimerNotify
        fun ref apply(timer: Timer, count: U64): Bool =>
          env.input(None)
          false
      end,
      Nanos.from_millis(10)
    )
    _timer = timer // Aliasing iso as tag is OK because you can't see inside a tag object
    _timers(consume timer)

  fun ref apply(data: Array[U8 val] iso) =>
    try _timers.cancel(_timer as Timer tag) end
    arr = arr + String.from_iso_array(consume data)

  fun dispose() =>
    try
      let words = arr.split(" ")
      let x: I64 = words(0)?.i64()?
      let y: I64 = words(1)?.i64()?
      Output.addNumbers(env, x, y)
    else
      env.err.print(
        "whack-a-test: please provide addition arguments, " +
        "either through command line arguments or to stdin"
      )
    end

actor Main
  new create(env: Env) =>
    let handler: Handler = Handler.create(env)
    if env.args.size() > 1 then
      try
        let x: I64 = env.args(1)?.i64()?
        let y: I64 = env.args(2)?.i64()?
        Output.addNumbers(env, x, y)
      end
    else
      env.input.apply(consume handler)
    end
