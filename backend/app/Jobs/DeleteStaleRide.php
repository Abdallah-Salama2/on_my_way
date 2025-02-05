<?php

namespace App\Jobs;

use App\Models\Ride;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class DeleteStaleRide implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $ride;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct(Ride $ride)
    {
        $this->ride = $ride;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        \Log::info("Processing job for ride ID: {$this->ride->id}");

        if ($this->ride->status === 'pending' && $this->ride->created_at->diffInMinutes(now()) >= 5) {
            \Log::info("Deleting ride ID: {$this->ride->id}");
            $this->ride->delete();
        }
    }
}
