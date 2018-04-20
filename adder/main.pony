actor Main
  new create(env: Env) =>
    try
      let x: I32 = env.args(1)?.i32()?
      let y: I32 = env.args(2)?.i32()?
      env.out.print(x.string() + " + " + y.string() + " = " + (x+y).string())
    end
