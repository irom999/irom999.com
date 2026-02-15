<article container mxa mt8 px-4 max-w-3xl>
	<!-- Header with profile image and name -->
	<div flex items-center gap-4 mb-4>
		<img src="/my_pic.JPG" alt="profile" class="rounded-full size-16" grayscale />
		<div>
			<h1 font="mono bold" text="3xl">irom999</h1>
			<span animate-pulse font-medium text="center xl text-700 dark:text-200">
				Software Engineer
			</span>
		</div>
	</div>

	<!-- Bio content -->
	<div prose="~ dark:invert" mxa mt-8>
		<h2 text="2xl" font-bold mb-4>Bio</h2>
		<p text-lg mb-1>Born in 1999. Software Engineer in Tokyo.</p>

		<!-- GitHub Link -->
		<div mt-6>
			<div
				cursor-pointer
				hover="scale-110 shadow-xl z-10 bg-[#88888811] op100"
				op-card
				transition-base
				inline-block
			>
				<a
					aria-label="link to irom999's github"
					href="https://github.com/irom999"
					rel="noopener noreferrer"
					target="_blank"
				>
					<div class="i-line-md:github-loop" text-5xl></div>
				</a>
			</div>
		</div>
	</div>
</article>
